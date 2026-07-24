const executionPlan = {
  executionSteps: [
    // Lista de nodos
    {
      referredType: "TEST_FALLA_MAYOR",
      joinPolicy: "ALL",
      failurePolicy: "STOP"
    },
    {
      referredType: "TEST_ONU",
      joinPolicy: "ALL",
      failurePolicy: "STOP"
    },
    {
      referredType: "TEST_HSI",
      joinPolicy: "ALL",
      failurePolicy: "STOP"
    },
    {
      referredType: "TEST_PORT",
      joinPolicy: "ALL",
      failurePolicy: "STOP"
    },
  ],
  executionTransitions: [
    // Lista de transiciones con condiciones
    {
      from: "TEST_FALLA_MAYOR",
      to: "TEST_ONU",
      guard: [ // Se hace el and de las guard en esta lista, el or se modela como varias transiciones
        { // Habilita una transicion (condiciones sobre el test from)
          metricName: "TEST_RESULT",
          hasRuleViolation: false,
          type: "RuleViolationGuard"
          // sigue la ejecucion si no hay violaciones para la 
          // medida TEST_RESULT
        }
      ]
    },
    {
      from: "TEST_ONU",
      to: "TEST_HSI",
      guard: [
        {
          type: "RuleViolationGuard",
          metricName: "PHASE_STATE",
          hasRuleViolation: false,
        }
      ]
    },
    {
      from: "TEST_ONU",
      to: "TEST_PORT",
      guard: [
        {
          type: "RuleViolationGuard",
          metricName: "PHASE_STATE",
          hasRuleViolation: true,
        }
      ]
    }
  ]
};