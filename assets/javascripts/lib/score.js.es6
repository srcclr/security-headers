export function scoreIs(score) {
  if (score > 0 && score < 20) {
    return 0;
  } else if (score > 20 && score < 70) {
    return 1;
  }

  return 2;
};

export function statusIs(score) {
  let status = ['bad', 'poor', 'excellent'];

  return status[scoreIs(score)];
};
