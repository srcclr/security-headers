export function scoreIs(score) {
  if (score < 0) {
    return 0;
  } else if (score < 10) {
    return 1;
  }

  return 2;
};

export function statusIs(score) {
  let status = ['bad', 'poor', 'excellent'];

  return status[scoreIs(score)];
};

export function gradeIs(score) {
  if (score < 0) {
    return 'D';
  } else if (score < 5) {
    return 'C';
  } else if (score < 10) {
    return 'B';
  }

  return 'A';
}

export let ratings =
  [
    { name: 'excellent', selected: false, scoreRange: [10,15] },
    { name: 'poor', selected: false, scoreRange: [0,9] },
    { name: 'bad', selected: false, scoreRange: [-15,-1] }
  ]

export let issueTypes =
  [
    { name: 'strict-transport-security', selected: false },
    { name: 'x-xss-protection', selected: false },
    { name: 'x-content-type-options', selected: false },
    { name: 'x-download-options', selected: false },
    { name: 'x-frame-options', selected: false },
    { name: 'public-key-pins', selected: false },
    { name: 'x-permitted-cross-domain-policies', selected: false }
  ]
