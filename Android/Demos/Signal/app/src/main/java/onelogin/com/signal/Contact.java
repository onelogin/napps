/*
 * Copyright (C) 2013 Surviving with Android (http://www.survivingwithandroid.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package onelogin.com.signal;

import java.io.Serializable;

public class Contact implements Serializable {
	
	private String date;
	private String tweet_id;
	private String picture_url;
	private String user_name;
    private Number type;
    private String text;


    public Contact(String date, String tweet_id, String picture_url, String user_name, String text, Number type) {
		super();
		this.setDate(date);
		this.setTweet_id(tweet_id);
		this.setPicture_url(picture_url);
		this.setUser_name(user_name);
        this.setText(text);
        this.setType(type);
	}


    public String getDate() {
        return date;
    }

    public void setType(Number type) {
        this.type = type;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getTweet_id() {
        return tweet_id;
    }

    public void setTweet_id(String tweet_id) {
        this.tweet_id = tweet_id;
    }

    public String getPicture_url() {
        return picture_url;
    }

    public void setPicture_url(String picture_url) {
        this.picture_url = picture_url;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public String getText() {
        return text;
    }

    public Number getType() {
        return type;
    }

    public void setText(String text) {
        this.text = text;
    }
}
