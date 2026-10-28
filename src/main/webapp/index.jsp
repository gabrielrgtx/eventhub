<html>
<body>
<h2>${empty param.id ? 'Create Event' : 'Edit Event'}</h2>

<form action="/create-event" method="post">

    <input type="hidden" name="id" value="${param.id}">

    <label>Event Name</label>
    <input type="text" name="event-name" id="event-name" value="${param.name}">

    <button type="submit">Register</button>

</form>

</body>
</html>