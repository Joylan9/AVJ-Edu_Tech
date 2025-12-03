package com.example.backend.model;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "courses")
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    private String shortDescription;

    @Column(columnDefinition = "TEXT")
    private String fullDescription;

    @Enumerated(EnumType.STRING)
    private Level level;

    private Integer durationMinutes;

    private String category;

    private String thumbnailUrl;

    private boolean isPublished = false;

    @ManyToOne
    @JoinColumn(name = "created_by")
    private User createdBy;

    @OneToMany(mappedBy = "course", cascade = CascadeType.ALL)
    private List<Module> modules;

    public enum Level { BEGINNER, INTERMEDIATE, ADVANCED }
}
