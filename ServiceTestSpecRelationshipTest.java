package com.example.demo.model;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.openapitools.model.Guard;
import org.openapitools.model.ServiceTestSpecRelationship;

class ServiceTestSpecRelationshipTest {

  @Test
  void serviceTestSpecRelationship() {

    ServiceTestSpecRelationship root = createMayorFaultRelationship();

    System.out.println("### INICIO recorrida ###");

    printRelationship(root,0);

    System.out.println("### FIN recorrida ###");

  }

  private void printRelationship(ServiceTestSpecRelationship root, int level) {

    for(int i = 0; i < level; i++) {
      System.out.print("\t");
    }
    System.out.println(root.getAtReferredType());
    for (ServiceTestSpecRelationship child : root.getChildren()) {
      printRelationship(child, level + 1);
    }
  }

  private ServiceTestSpecRelationship createMayorFaultRelationship() {

    ServiceTestSpecRelationship rootRelationship = new ServiceTestSpecRelationship();

    rootRelationship.setRelationshipType("executionTree");
    rootRelationship.setAtReferredType("TEST_FALLA_MAYOR");
    ServiceTestSpecRelationship testOnu = createTestOnuRelationship();
    ServiceTestSpecRelationship testHsi = createTestHsiRelationship();
    rootRelationship.setChildren(List.of(testOnu, testHsi));

    return rootRelationship;
  }

  private ServiceTestSpecRelationship createTestOnuRelationship() {
    ServiceTestSpecRelationship rootRelationship = new ServiceTestSpecRelationship();

    rootRelationship.setRelationshipType("executionTree");
    rootRelationship.setAtReferredType("TEST_ONU");

    Guard guard = new Guard();
    guard.setAtReferredType("TEST_FALLA_MAYOR");
    guard.setMetricName("TEST_RESULT");
    guard.setHasRuleViolation(false);
    guard.setAtType("RuleViolationGuard");

    rootRelationship.setGuardList(List.of(guard));

    ServiceTestSpecRelationship testPort = createTestPortRelationship();
    rootRelationship.setChildren(List.of(testPort));

    return rootRelationship;
  }

  private ServiceTestSpecRelationship createTestHsiRelationship() {
    ServiceTestSpecRelationship rootRelationship = new ServiceTestSpecRelationship();

    rootRelationship.setRelationshipType("executionTree");
    rootRelationship.setAtReferredType("TEST_HSI");

    Guard guard = new Guard();
    guard.setAtReferredType("TEST_FALLA_MAYOR");
    guard.setMetricName("TEST_RESULT");
    guard.setHasRuleViolation(false);
    guard.setAtType("RuleViolationGuard");

    rootRelationship.setGuardList(List.of(guard));

    return rootRelationship;
  }

  private ServiceTestSpecRelationship createTestPortRelationship() {

    ServiceTestSpecRelationship rootRelationship = new ServiceTestSpecRelationship();

    rootRelationship.setRelationshipType("executionTree");
    rootRelationship.setAtReferredType("TEST_PORT");

    Guard guard = new Guard();
    guard.setAtReferredType("TEST_ONU");
    guard.setMetricName("PHASE_STATE");
    guard.setHasRuleViolation(true);
    guard.setAtType("RuleViolationGuard");

    rootRelationship.setGuardList(List.of(guard));

    return rootRelationship;

  }
}
