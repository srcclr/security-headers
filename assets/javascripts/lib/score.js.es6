export function gradeIs(score) {
  let grade = ["D", "C", "B", "A"];

  return grade[score];
}

export let ratings =
  [
    { name: 'A', selected: false, score: 3 },
    { name: 'B', selected: false, score: 2 },
    { name: 'C', selected: false, score: 1 },
    { name: 'D', selected: false, score: 0 }
  ]

export let headerTypes =
  [
    { name: 'strict-transport-security', selected: false },
    { name: 'x-xss-protection', selected: false },
    { name: 'x-content-type-options', selected: false },
    { name: 'x-download-options', selected: false },
    { name: 'x-frame-options', selected: false },
    { name: 'public-key-pins', selected: false },
    { name: 'x-permitted-cross-domain-policies', selected: false },
    { name: 'content-security-policy', selected: false }
  ]
