package com.example.backend.model;
import jakarta.persistence.*;
@Entity
@Table(name = "answer_options")
public class AnswerOption {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne @JoinColumn(name = "question_id")
    private Question question;

    private String text;

    private boolean isCorrect = false;
}
