package com.example.backend.model;
import jakarta.persistence.*;

import java.util.Date;
@Entity
@Table(name = "live_sessions")
public class LiveSession {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    private String description;

    @ManyToOne @JoinColumn(name = "course_id")
    private Course course;

    private Date startTime;

    private Date endTime;

    private String joinUrl;

    private String recordingUrl;
}

