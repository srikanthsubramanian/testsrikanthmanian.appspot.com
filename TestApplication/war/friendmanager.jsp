<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>

<html>
<head>
<title>Test Application - Friend Manager</title>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
</head>

<body>
<% 	
	String friendList=request.getParameter("friendList");
	if(friendList==null){
		friendList = "default friend list";
	}
	  pageContext.setAttribute("friendList", friendList);
	  
	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();	

	if (user != null) {
	  pageContext.setAttribute("user", user);
	  friendList = user.getNickname()+"'s Friend List";
%>
<p>
	Hello, <%= user.getNickname() %> (You can <a
		href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign
		out</a>.)
</p>
<%
} else {
%>
<p>
	Hello! Welcome to Friend Manager.</p>
	<p> <a
		href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign
		in</a> to add your friends to your list.
</p>
<%
}
%>

<%
if (user != null) {
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key friendListKey = KeyFactory.createKey("FriendListKey", friendList);
    Query query = new Query("Friend", friendListKey);
    List<Entity> friendsList = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
    if (friendsList.isEmpty()) {
        %>
	<p><%= friendList %> has no friends.</p>
	<%
    } else {
        %>
	<p>Entries in <%= friendList %>.</p>
	<%
        for (Entity friend : friendsList) {
        	 if (friend.getProperty("user") == null) {
     %>
     <p>An anonymous person wrote :</p>
     
			 	<%
			 	pageContext.setAttribute("friend_user",friend.getProperty("user"));
			             } else {
			                 pageContext.setAttribute("friend_user",friend.getProperty("user"));
			             }
                 %>
                <blockquote><b><%= friend.getProperty("friendName") %></b></blockquote>
				<blockquote><b><%= friend.getProperty("friendMail") %></b></blockquote>
	<%
    }
  }
}
%>

<%if (user != null) {%>
<form action="/addfriend" method="post">
	<div>
		Friend's Name : <input name="friendName" type="text">
	</div>
	<div>
		Email : <input name="friendMail" type="email">
	</div>
	<div>
		<input type="submit" value="Add Friend" />
	</div>
	<input type="hidden" name="friendList"
		value="<%= friendList %>" />
</form>
<%} %>

</body>
</html>