package com.satya.apps.conrtroller;

import com.satya.apps.entity.User;
import com.satya.apps.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;


@RestController
@RequestMapping("api/v1/users")
public class UserController {

    public static final Logger logger = LoggerFactory.getLogger(UserController.class);
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public List<User> getUsers() {
        logger.info("Fetching all users");
        return userService.findAll();
    }

    @PostMapping
    public void createUser(@RequestBody User user) {
        logger.info("Creating a new user: {}", user);
        userService.save(user);
    }

}
