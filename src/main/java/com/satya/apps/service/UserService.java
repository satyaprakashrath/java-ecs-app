package com.satya.apps.service;

import com.satya.apps.entity.User;
import com.satya.apps.respository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
@Service
public class UserService {

    private final UserRepository userRepository;

public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
    public void save(User user) {
        User u = new User();
        u.setUsername("satya"); // IntelliJ should recognize `setUsername`
        String name = u.getUsername(); // No red squiggle = ✅ Lombok is working
        userRepository.save(user);
    }

    public List<User> findAll() {
        return userRepository.findAll();

    }
}
