package com.example.backend.model;

import jakarta.persistence.*;

@Entity
@Table(name = "lessons")
public class Lesson {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "module_id")
    private Module module;

    private String title;

    @Enumerated(EnumType.STRING)
    private ContentType contentType;

    @Column(columnDefinition = "LONGTEXT")
    private String contentHtml;

    private String contentUrl;

    private Integer durationMinutes;

    private Integer orderIndex;

    public enum ContentType { VIDEO, ARTICLE, HTML, SCORM }
}
