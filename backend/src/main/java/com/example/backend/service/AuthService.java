package com.example.backend.service;

import com.example.backend.DTO.AuthResponse;
import com.example.backend.DTO.LoginRequest;
import com.example.backend.DTO.RegisterRequest;
import com.example.backend.model.User;
import com.example.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Service
public class AuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    @Autowired
    public AuthService(UserRepository userRepository, UserRepository userRepository1, PasswordEncoder passwordEncoder)
    {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public AuthResponse register(RegisterRequest registerRequest)
    {
        if(userRepository.existsByEmail(registerRequest.getEmail()))
        {
            return new AuthResponse(false,"Email already exists",null,null,null);
        }
        User user=new User();
        user.setFullName(registerRequest.getFullName());
        user.setEmail(registerRequest.getEmail());
        user.setPasswordHash(passwordEncoder.encode(registerRequest.getPassword()));
        user.setRole(User.Role.LEARNER);
        User saved=userRepository.save(user);
        String token="dummy-token";
        return new AuthResponse(true,"Registartion Succcess",token,saved.getId(),saved.getRole().name());
    }


    public AuthResponse login(LoginRequest loginRequest) {

        User user=userRepository.findByEmail(loginRequest.getEmail()).orElse(null);
        if(user==null)
        {
            return new AuthResponse(false,"User not Found",null,null,null);
        }
        if(!passwordEncoder.matches(loginRequest.getPassword(),user.getPasswordHash()))
        {
            return new AuthResponse(
                    false,
                    "Wrong password",
                    null,
                    null,
                    null
            );
        }
        String token = "dummy-token-for-user-" + user.getId();

        return new AuthResponse(
                true,
                "Login successful",
                token,
                user.getId(),
                user.getRole().name()
        );


    }
}
