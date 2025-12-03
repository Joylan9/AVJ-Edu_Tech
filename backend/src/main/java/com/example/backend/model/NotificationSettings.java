package com.example.backend.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "notification_settings")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class NotificationSettings {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;

    private boolean courseAlertsEmail = true;
    private boolean courseAlertsPush = true;
    private boolean contentCommunityEmail = true;
    private boolean contentCommunityPush = true;
    private boolean generalEmail = true;
    private boolean generalPush = true;
}

