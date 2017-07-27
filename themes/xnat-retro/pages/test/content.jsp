<%@ page contentType="text/html" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="pg" tagdir="/WEB-INF/tags/page" %>

<div id="page-wrapper">
    <div class="pad">

        <pg:restricted msg="Members Only">
            <h1>YOU'RE AN ADMIN</h1>
        </pg:restricted>

        <br>

        <small>(This JSP page takes priority)</small>

        <br>
        <br>

        <b>&lt;content.html&gt;</b>
        <div style="border:1px solid #ccc;">
            <div style="margin:30px;">
                <%@ include file="content.html" %>
                <%--<c:import url="/themes/${themeName}/pages/test/content.html"/>--%>
            </div>
        </div>
        <b>&lt;/content.html&gt;</b>

        <br>
        <br>

        <small>content.html file imported above</small>

    </div>
</div>
<!-- /#page-wrapper -->
