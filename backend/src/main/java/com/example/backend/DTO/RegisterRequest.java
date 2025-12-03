package com.example.backend.DTO;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
@Setter
@Getter
public class RegisterRequest {
    private String fullName;
    private String email;
    private String password;
}

