<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
</head>
<body>
    <h1>Eventos</h1>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Nome</th>
            <th>Actions</th>
        </tr>
        <c:forEach var="evento" items="${eventos}">
            <tr>
                <td>${evento.id}</td>
                <td>${evento.nome}</td>
                <td>
                    <form action="/delete-event" method="post">
                        <input type="hidden" id="id" name="id" value="${evento.id}">
                        <button type="submit">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>