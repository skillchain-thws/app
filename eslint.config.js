import antfu from '@antfu/eslint-config'

export default antfu(
  {
    rules: {
      'no-console': 'off',
      'style/max-statements-per-line': 'off',
      'eslinteslint-comments/no-unlimited-disable': 'off',
      'import/order': 'off',
    },
  },
)
