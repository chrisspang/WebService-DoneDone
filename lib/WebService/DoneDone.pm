package WebService::DoneDone;

use strict;
use warnings;

use Moo;
with 'WebService::Client';

# VERSION

# ABSTRACT: Client library for DoneDone API v2

use Carp qw(croak);
#use MIME::Entity;
use JSON qw(encode_json);
use MIME::Base64;

has username => ( is => 'ro', required => 1 );
has password => ( is => 'ro', required => 1 );

has '+base_url' => ( default => 'https://www.mydonedone.com/issuetracker/api/v2' );

sub BUILD {
    my ($self) = @_;

    my $u = $self->username();
    my $p = $self->password();
    my $base64_encoded_auth = encode_base64("$u:$p");
    $self->ua->default_header(Authorization => "Basic " . $base64_encoded_auth);
}

## Companies and People

sub get_companies {
    my ($self, %args) = @_;
    return $self->get("/companies.json");
}

sub get_company_details {
    my ($self, $company) = @_;
    return $self->get("/companies/${company}.json");
}

sub get_person {
    my ($self, $person) = @_;
    return $self->get("/people/${person}.json");
}

sub create_company {
    my ($self, $data) = @_;
    return $self->post("/companies.json", $data);
}

sub update_company_name {
    my ($self, $company, $data) = @_;
    croak '$data is required' unless 'HASH' eq ref $data;
    return $self->put("/companies/${company}.json", $data);
}

## Projects

sub get_projects {
    my ($self) = @_;
    return $self->get("/projects.json");
}

sub get_project {
    my ($self, $id) = @_;
    return $self->get("/projects/${id}.json");
}

sub get_projects_people {
    my ($self, $id) = @_;
    return $self->get("/projects/${id}/people.json");
}

## Issues

sub create_issue {
    my ($self, $id, $data) = @_;
    croak '$data is required' unless 'HASH' eq ref $data;
    my $rv = $self->post("/projects/${id}/issues.json", $data,
                       'Content-Type' => 'application/x-www-form-urlencoded');
    return $rv;
}

sub get_issue {
    my ($self, $project_id, $issue_id) = @_;
    return $self->get("/projects/${project_id}/issues/${issue_id}.json");
}

sub add_issue_comment {
    my ($self, $project_id, $issue_id, $data) = @_;
    return $self->post("/projects/${project_id}/issues/${issue_id}/comment.json", $data);
}

sub update_issue_status {
    my ($self, $project_id, $issue_id, $data) = @_;
    croak '$data is required' unless 'HASH' eq ref $data;
    return $self->put("/projects/${project_id}/issues/${issue_id}/status.json", $data);
}

sub update_issue_fixer {
    my ($self, $project_id, $issue_id, $data) = @_;
    croak '$data is required' unless 'HASH' eq ref $data;
    return $self->put("/projects/${project_id}/issues/${issue_id}/fixer.json", $data);
}

sub update_issue_tester {
    my ($self, $project_id, $issue_id, $data) = @_;
    croak '$data is required' unless 'HASH' eq ref $data;
    return $self->put("/projects/${project_id}/issues/${issue_id}/tester.json", $data);
}

sub update_issue_priority {
    my ($self, $project_id, $issue_id, $data) = @_;
    croak '$data is required' unless 'HASH' eq ref $data;
    return $self->put("/projects/${project_id}/issues/${issue_id}/priority_level.json", $data);
}

sub get_available_reassignees {
    my ($self, $project_id, $issue_id, $data) = @_;
    return $self->get("/projects/${project_id}/issues/${issue_id}/people/available_for_reassignment.json");
}

sub get_available_statuses {
    my ($self, $project_id, $issue_id, $data) = @_;
    return $self->get("/projects/${project_id}/issues/${issue_id}/statuses/available_to_change_to.json");
}

## Issue Lists

sub get_waiting_on_you {
    my ($self) = @_;
    return $self->get("/issues/waiting_on_you.json");
}

sub get_project_waiting_on_you {
    my ($self, $id) = @_;
    return $self->get("/projects/${id}/issues/waiting_on_you.json");
}

sub get_waiting_on_them {
    my ($self) = @_;
    return $self->get("/issues/waiting_on_them.json");
}

sub get_project_waiting_on_them {
    my ($self, $id) = @_;
    return $self->get("/projects/${id}/issues/waiting_on_them.json");
}

sub get_ccd_on {
    my ($self) = @_;
    return $self->get("/issues/youre_ccd_on.json");
}

sub get_project_ccd_on {
    my ($self, $id) = @_;
    return $self->get("/projects/${id}/issues/youre_ccd_on.json");
}

sub get_active_issues {
    my ($self) = @_;
    return $self->get("/issues/your_active.json");
}

sub get_project_active_issues {
    my ($self, $id) = @_;
    return $self->get("/projects/${id}/issues/your_active.json");
}

sub get_issues {
    my ($self) = @_;
    return $self->get("/issues/all_yours.json");
}

sub get_project_issues {
    my ($self, $id) = @_;
    return $self->get("/projects/${id}/issues/all_yours.json");
}

# Issues (all)

sub get_all_active_issues {
    my ($self) = @_;
    return $self->get("/issues/all_active.json");
}

sub get_project_all_active_issues {
    my ($self, $id) = @_;
    return $self->get("/projects/${id}/issues/all_active.json");
}

sub get_all_closed_and_fixed_issues {
    my ($self) = @_;
    return $self->get("/issues/all_closed_and_fixed.json");
}

sub get_project_all_closed_and_fixed_issues {
    my ($self, $id) = @_;
    return $self->get("/projects/${id}/issues/all_closed_and_fixed.json");
}

sub get_all_on_hold_issues {
    my ($self) = @_;
    return $self->get("/issues/all_on_hold.json");
}

sub get_project_all_on_hold_issues {
    my ($self, $id) = @_;
    return $self->get("/projects/${id}/issues/all_on_hold.json");
}

sub get_all_issues {
    my ($self) = @_;
    return $self->get("/issues/all.json");
}

sub get_project_all_issues {
    my ($self, $id) = @_;
    return $self->get("/projects/${id}/issues/all.json");
}

sub get_filtered_issues {
    my ($self, $filter_id) = @_;
    return $self->get("/issues/by_global_custom_filter/${filter_id}.json");
}

sub get_project_filtered_issues {
    my ($self, $project_id, $filter_id) = @_;
    return $self->get("/projects/${project_id}/issues/by_custom_filter/${filter_id}.json");
}

## Release builds

## Levels and Types

sub get_priority_levels {
    my ($self) = @_;
    return $self->get("/priority_levels.json");
}

sub get_creation_types {
    my ($self) = @_;
    return $self->get("/issue_creation_types.json");
}

sub get_sort_types {
    my ($self) = @_;
    return $self->get("/issue_sort_types.json");
}

1;

=head1 DESCRIPTION

Simple client for talking to DoneDone API v2.

=head1 METHODS

=head2 username

=head2 password

=for Pod::Coverage BUILD

=head1 COMPANIES AND PEOPLE

=head1 PROJECTS

=head1 ISSUES

=head1 ISSUE LISTS

=head1 RELEASE BUILDS

=head1 LEVELS AND TYPES

=cut
