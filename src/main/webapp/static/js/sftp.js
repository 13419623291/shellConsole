$(document).ready(function(){
	$('#message').html('文件加载中...');
	$("#msgModal").modal('show');

	$.getJSON('/sshController/connectSftp', function(data){
		showFiles(data);
	});
	/* $("#message").removeClass("alert alert-danger").addClass("alert alert-danger");
	$('#message').html('loading error.');
	$("#msgModal").modal('hide'); */

});
$("#attrModal").on("hidden.bs.modal", function() {
    $(this).removeData("bs.modal");
    $('input[type=checkbox]').each(function(){
    	$(this).removeAttr('checked');
    })
    $('#permissions').val('');
});
$('input[type=checkbox]').click(function(){
	$p = 0; 
	$('input[type=checkbox]').each(function(){
		if ($(this).is(':checked'))
			$p += parseInt($(this).val());
	 });
	$('#permissions').val($p);
})
function initAttr(p, fileName) {
	$('#attrModalLabel').html(fileName);
	$('#subAttr').attr('onclick',"setAttr('"+fileName+"')");
	p = parseInt(p);
	$('#permissions').val(p.toString(8).slice(-3));
	if (p%2==1) {
		$('#othE').prop('checked',true)
	}
	p = p>>1;
	if (p%2==1) {
		$('#othW').prop('checked',true)
	}
	p = p>>1;
	if (p%2==1) {
		$('#othR').prop('checked',true)
	}
	p = p>>1;
	if (p%2==1) {
		$('#grpE').prop('checked',true)
	}
	p = p>>1;
	if (p%2==1) {
		$('#grpW').prop('checked',true)
	}
	p = p>>1;
	if (p%2==1) {
		$('#grpR').prop('checked',true)
	}
	p = p>>1;
	if (p%2==1) {
		$('#usrE').prop('checked',true)
	}
	p = p>>1;
	if (p%2==1) {
		$('#usrW').prop('checked',true)
	}
	p = p>>1;
	if (p%2==1) {
		$('#usrR').prop('checked',true)
	}
}
function downLoadFile(fileName) {
	var form = $("<form>");
    form.attr('style', 'display:none');
    form.attr('target', '_blank');
    form.attr('method', 'post');
    form.attr('action', "/sshController/downloadFile");

    var input1 = $('<input>');
    input1.attr('type', 'hidden');
    input1.attr('name', 'fileFileName');
    input1.attr('value', fileName);
    $('body').append(form);
    form.append(input1);
    form.submit();
}

function refreshProgress(date) {
	$.get('/sshController/uploadState?t=' + new Date().getTime(),function(data){
		data = jQuery.parseJSON(data);
		$('.progress-bar').css('width',data.percent);
		$('#percent').html(data.percent);
		$('#sop'+date).html(data.percent);
		$('#state').html(data.percent);
		if (data.percent != '100.00%'){
			setTimeout(refreshProgress(date), 100);
        }else{
            $('#result'+date).html("上传成功");
            $('#time'+date).html(dateFormate(new Date()));
            $('#file').val('');
        }
	});
};
//create new fodder
$('#subCreate').click(function(){
	$fName = $('#fName').val();
	if ($.trim($fName)=="") {
		alert("Fodder name is empty!");
		return;
	}
	exec('mkdir', $fName);
})

/**
 * 校验文件
 */
function uploadFile() {
    var file = $('#file').get(0).files[0];
    if (file.name == '' || file.name == undefined) {
        return;
    }
    var fileBulk = Math.round(file.size * 100 / (1024 * 1024)) / 100;
    if(fileBulk >=800){
        $('#message').html('单个文件大小不能超过80M');
        $("#msgModal").modal('show');
        setTimeout(function(){$("#msgModal").modal('hide');}, 2000);
        $('#file').val('');
        return ;
	}
    var fileSize= (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';
    //判断文件是否存在
    $.post('/sshController/exist', {'fileName': file.name}, function (data) {
        if (data == 'true') {
            if (!confirm("文件" + file.name + "已存在。是否覆盖？")) {
                return;
            }
        }
        $("#ftpName").html(file.name);
        var date=new Date().getTime();
        var trTd='<tr><td>'+$("#currentCatalog").val()+'/'+file.name+'</td><td>'+file.name+'</td><td>'+file.type+'</td><td>'+fileSize+'</td><td id="sop'+date+'"></td><td id="result'+date+'"></td><td>'+dateFormate(date)+'</td><td id="time'+date+'"></td></tr>';
        $("#historyTable tbody").append(trTd);
        fileUpload(date);
    });
};

/**
 * 上传文件
 */
function fileUpload(date){
    $.ajaxFileUpload({
        url: '/sshController/upload',
        type: 'post',
        secureuri: false,
        fileElementId: 'file',
        dataType: 'json',
        elementIds: '',
        success: function(data, status){
            $('#message').html('文件加载中...');
            $("#msgModal").modal('show');
            showFiles(data);
        },
        error: function(data, status, e){
            $('#progress').html("upload failed.");
        }
    });
    refreshProgress(date);
}

function setAttr(fileName) {
	$('#message').html('文件加载中...');
	$("#msgModal").modal('show');
	$.post('/sshController/execCommand', {'cmd':'attr', 'fileFileName':fileName, 'permissions':$('#permissions').val()}, function(data){
		showFiles(jQuery.parseJSON(data));
	});
}
function exec(cmd, cmdParam) {
	$("#message").removeClass("alert alert-danger").addClass("alert alert-success");
	$('#message').html('文件加载中...');
	$("#msgModal").modal('show');
	$.post('/sshController/execCommand', {'cmd':cmd, 'cmdParam':cmdParam}, function(data){
		showFiles(jQuery.parseJSON(data));
	});
};
function initRemoveModal(fileName) {
    $('#removeModal .modal-body').html('确定删除'+fileName+'?');
	$('#subRemove').attr("onclick", "exec('rm','"+fileName+"')");
}
function showFiles(data) {
	if (data.code == '201' || data.code == '203') {
		$("#message").removeClass("alert alert-success").addClass("alert alert-danger");
		$('#message').html(data.msg);
		setTimeout(function(){$("#msgModal").modal('hide');}, 2000);
		return ;
	}
	
	$('#currentCatalog').val(data.currentCatalog);
	if (data != undefined && data != "")
		$('#file-list').empty();
	
	if (data.currentCatalog != "/") {
		$tr = '<tr><td>&nbsp;<span class="glyphicon glyphicon-folder-open"></span>&nbsp;&nbsp;　<a href="javascript:void(0)" onclick="exec(\'cd\',\'..\')">..</a></td><td></td><td></td><td></td><td></td></tr>'
		$('#file-list').append($tr);
		var currentCatalogArry=data.currentCatalog.split("/");
		var currentCatalog='';
        var log='';
		for (var i=0;i<currentCatalogArry.length;i++){
			if(i !==0){
                log+='/'+currentCatalogArry[i];
                currentCatalog+='/<span onclick="exec(\'cds\',\''+log+'\')">'+currentCatalogArry[i]+'</span>'
			}
		}
        $('#catalog').html(currentCatalog);
    }else{
        $('#catalog').html(data.currentCatalog);
	}

	$(data.files).each(function(i, e){
		if (e.directory) {
			$tr = '<tr><td>&nbsp;<span class="glyphicon glyphicon-folder-open"></span>&nbsp;　<a href="javascript:void(0)" onclick="exec(\'cd\',\''+e.filename+'\')">' +e.filename+ '</a></td><td></td><td>'+e.mtime+'</td><td>'+e.strPermissions+'</td><td>  </td></tr>';
		} else {
			$tr = '<tr><td>&nbsp;<span class="glyphicon glyphicon-file"></span>　'+e.filename+'</td><td>'+e.size+'</td><td>'+e.mtime+'</td><td>'+e.strPermissions+'</td><td><a class="glyphicon glyphicon-trash pull-right" data-toggle="modal" data-target="#removeModal" href="javascript:void(0)" title="删除" style="color:red;outline:none" onclick="initRemoveModal(\''+e.filename+'\')"></a><a class="glyphicon glyphicon-download-alt pull-right" href="javascript:void(0)" title="下载" style="margin-right:10px;color:#FF9933;outline:none" onclick="downLoadFile(\''+e.filename+'\')"></a></td></tr>';
		}
		$('#file-list').append($tr);
	});
	$("#msgModal").modal('hide');
}

function dateFormate(value){
    var date = new Date(value);
    return date_value=date.getFullYear() + '-' + (getzf(date.getMonth() + 1)) + '-' + getzf(date.getDate()) + ' ' + getzf(date.getHours()) + ':' + getzf(date.getMinutes()) + ':' + getzf(date.getSeconds());
};
//补0操作
function getzf(num){
    if(parseInt(num) < 10){
        num = '0'+num;
    }
    return num;
};

function loginSsh () {
	location.href="/sshController/openShell";
};