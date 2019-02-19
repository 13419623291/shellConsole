<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-cn">
<script type="text/javascript">
    //此种方式降低了js和CSS的耦合性
    function changeFontSize2(fontStyle){
// 获取节点对象
        var divNode = document.getElementById("size");
// 设置该节点的Name属性以及属性值
        divNode.style.fontSize=fontStyle;
    }
    /*
    function changeFontSize2(fontSize){
    // 获取节点对象
    var divNode = document.getElementsByTagName("div")[0];
    divNode.style.fontSize=fontSize;
    }
    */
</script>
<body>
<h2>Hello World!</h2>
<a href="javascript:void(0)" onclick="changeFontSize2('20px')" class="max">大号</a>
<a href="javascript:void(0)" onclick="changeFontSize2('16px')" class="moren">中号</a>
<a href="javascript:void(0)" onclick="changeFontSize2('12px')" class="min">小号</a>
<div id="size">
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
    <div>
        <p>
            这里呢就是显示的文字，通过点击上面的超链接改变此字体大小
        </p>
    </div>
</div>

</body>
</html>
