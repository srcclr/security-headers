export function scoreIs(score) {
  if (score >= 0 && score < 20) {
    return 0;
  } else if (score >= 20 && score < 70) {
    return 1;
  }

  return 2;
};

export function statusIs(score) {
  let status = ['bad', 'poor', 'excellent'];

  return status[scoreIs(score)];
};

export let ratings =
  [
    { name: 'excellent', selected: false, scoreRange: [70,100] },
    { name: 'poor', selected: false, scoreRange: [20,69] },
    { name: 'bad', selected: false, scoreRange: [0,19] }
  ]

export let issueTypes =
  [
    { name: 'strict-transport-security', selected: false },
    { name: 'x-xss-protection', selected: false },
    { name: 'x-content-type-options', selected: false },
    { name: 'x-download-options', selected: false },
    { name: 'x-frame-options', selected: false },
    { name: 'content-security-policy', selected: false },
    { name: 'public-key-pins', selected: false }
  ]
