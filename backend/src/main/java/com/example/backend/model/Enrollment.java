package com.example.backend.model;
import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(
        name = "enrollments",
        uniqueConstraints = @UniqueConstraint(columnNames = {"user_id", "course_id"})
)
public class Enrollment {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne @JoinColumn(name = "course_id")
    private Course course;

    @Enumerated(EnumType.STRING)
    private Status status = Status.ENROLLED;

    private Date enrolledAt;

    private Date completedAt;

    public enum Status { ENROLLED, COMPLETED, DROPPED }
}
