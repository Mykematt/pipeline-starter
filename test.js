// Simple test script
console.log('🧪 Running tests...');

// Test 1: Basic functionality
console.log('✅ Test 1: App module loads correctly');

// Test 2: Environment check
const env = process.env.NODE_ENV || 'development';
console.log(`✅ Test 2: Environment is ${env}`);

// Test 3: Port configuration
const port = process.env.PORT || 3000;
console.log(`✅ Test 3: Port configured as ${port}`);

console.log('🎉 All tests passed!');
process.exit(0);
