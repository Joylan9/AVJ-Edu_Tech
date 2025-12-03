package com.example.backend.model;
import jakarta.persistence.*;
@Entity
@Table(name = "quizzes")
public class Quiz {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "lesson_id", unique = true)
    private Lesson lesson;

    private String title;
}
