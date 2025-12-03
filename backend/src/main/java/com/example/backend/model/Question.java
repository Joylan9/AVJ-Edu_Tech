package com.example.backend.model;
import jakarta.persistence.*;
@Entity
@Table(name = "questions")
public class Question {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne @JoinColumn(name = "quiz_id")
    private Quiz quiz;

    private String text;

    @Enumerated(EnumType.STRING)
    private QuestionType type;

    private Integer orderIndex;

    public enum QuestionType { SINGLE_CHOICE, MULTI_CHOICE }
}
