package com.example.backend.controller;

import com.example.backend.DTO.AuthResponse;
import com.example.backend.DTO.LoginRequest;
import com.example.backend.DTO.RegisterRequest;
import com.example.backend.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final AuthService authService;

    @Autowired
    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@RequestBody RegisterRequest registerRequest)
    {
        AuthResponse authResponse=authService.register(registerRequest);
        if(authResponse.isSuccess())
        {
            return ResponseEntity.status(HttpStatus.CREATED).body(authResponse);
        }
        else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(authResponse);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@RequestBody LoginRequest loginRequest)
    {
        AuthResponse authResponse=authService.login(loginRequest);
        if(authResponse.isSuccess())
        {
            return ResponseEntity.status(HttpStatus.CREATED).body(authResponse);
        }
        else
        {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(authResponse);
        }
    }
}
