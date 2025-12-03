package com.example.backend.model;

import jakarta.persistence.*;

@Entity
@Table(name = "user_profile")
public class UserProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;

    private String jobTitle;

    @Enumerated(EnumType.STRING)
    private ExperienceLevel experienceLevel;

    private String company;

    @Column(columnDefinition = "TEXT")
    private String bio;

    public enum ExperienceLevel { BEGINNER, INTERMEDIATE, ADVANCED }
}
