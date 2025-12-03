package com.example.backend.model;
import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(
        name = "lesson_progress",
        uniqueConstraints = @UniqueConstraint(columnNames = {"enrollment_id", "lesson_id"})
)
public class LessonProgress {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne @JoinColumn(name = "enrollment_id")
    private Enrollment enrollment;

    @ManyToOne @JoinColumn(name = "lesson_id")
    private Lesson lesson;

    @Enumerated(EnumType.STRING)
    private Status status;

    private Date lastViewedAt;

    private Integer score;

    public enum Status { NOT_STARTED, IN_PROGRESS, COMPLETED }
}
