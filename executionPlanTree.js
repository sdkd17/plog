const rootStep = [
  // Lista de nodos
  {
    referredType: "TEST_FALLA_MAYOR",
    children: [
      {
        referredType: "TEST_ONU",
        guard: [ // Se hace el and de las guard en esta lista, el or se modela como varias transiciones
          { // Habilita una transicion (condiciones sobre el test from)
            metricName: "TEST_RESULT",
            hasRuleViolation: false,
            type: "RuleViolationGuard"
            // sigue la ejecucion si no hay violaciones para la 
            // medida TEST_RESULT
          }
        ],
        children: [
          {
            referredType: "TEST_HSI",
            guard: [
              {
                type: "RuleViolationGuard",
                metricName: "PHASE_STATE",
                hasRuleViolation: false,
              }
            ]
          },
          {
            referredType: "TEST_PORT",
            guard: [
              {
                type: "RuleViolationGuard",
                metricName: "PHASE_STATE",
                hasRuleViolation: true,
              }
            ]
          }
        ]
      },
    ]
  }
];
