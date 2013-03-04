package com.test.testapplication;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class AddFriendServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6353910337540049143L;
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		String friendList = req.getParameter("friendList");
		Key friendListKey = KeyFactory.createKey("FriendListKey", friendList);
		String friendName = req.getParameter("friendName");
		String friendMail = req.getParameter("friendMail");
		
		Entity friend = new Entity("Friend", friendListKey);
		friend.setProperty("user", user);
		friend.setProperty("friendName", friendName);
		friend.setProperty("friendMail", friendMail);

		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		datastore.put(friend);

		resp.sendRedirect("/friendmanager.jsp?friendList=" + friendList);
	}

}
