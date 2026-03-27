package com.crs.model;

public class Milestone {
    private int milestoneId;
    private int planId;
    private String week;
    private String task;
    private boolean completed;

    public Milestone(int milestoneId, int planId, String week, String task, boolean completed) {
        this.milestoneId = milestoneId;
        this.planId = planId;
        this.week = week;
        this.task = task;
        this.completed = completed;
    }

    public int getMilestoneId() { return milestoneId; }
    public int getPlanId() { return planId; }
    public String getWeek() { return week; }
    public String getTask() { return task; }
    public boolean isCompleted() { return completed; }
}