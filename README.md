<h1 align="center">
 Calypso
</h1>

![Logo de Calypso](assets/calypso-logo.png)

# Resume
Calypso is a communication program built in Ruby using TCP for communication and following the MVC (Model-View-Controller) design pattern. This pogram allows users to create or join chat rooms, with the option to set a password for security.

# Utilisation
```sh
git clone https://github.com/DALM1/Calypso.git
```

```sh
cd Calypso
```

```sh
gem install bundle
```

```sh
bundle install
```

```sh
ruby cal.rb
```


# 0.1 Beta Patch Note

1. User and Room Management Commands:

	•	/list : Lists the users present in the room.
	•	/info : Provides information about the room (name, creator, users).
	•	/hodor <newpass> : Changes the room’s password (only the creator can do this).
	•	/ban <username> : Bans a user from the room (only the creator can do this).
	•	/powerto <username> : Transfers the ownership of the room to another user.
	•	/erased <roomname> : Deletes the room (only the creator can do this).
	•	/axios <CurrentRoom> <NewRoom> : Redirects all users from one room to another and closes the current room.

2. Permission Management:

	•	Sensitive commands verify that only the creator of the room can execute them.

3. Proper Connection Management:

	•	Client connections are properly closed after the user leaves the room.
