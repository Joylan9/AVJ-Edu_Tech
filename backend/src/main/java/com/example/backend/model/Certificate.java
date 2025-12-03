package com.example.backend.model;
import jakarta.persistence.*;

import java.util.Date;
@Entity
@Table(name = "certificates")
public class Certificate {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne @JoinColumn(name = "course_id")
    private Course course;

    private String certificateNumber;

    private Date issuedAt;

    private String pdfUrl;
}
