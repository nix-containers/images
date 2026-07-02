{ pkgs, image }:

pkgs.writeShellScript "test-postgres-cloudnative-pg" ''
  set -euo pipefail

  echo "🧪 Testing postgres-cloudnative-pg image functionality..."

  # Test 1: PostgreSQL version (passed through by the entrypoint).
  echo "  ✓ Testing postgres version..."
  docker run --rm ${image.imageName}:test postgres --version | grep -q "postgres"

  # Test 2: PostgreSQL client tools.
  echo "  ✓ Testing postgres tools..."
  docker run --rm ${image.imageName}:test which psql | grep -q "psql"

  # Test 3: pgvector extension is bundled (control file on the extension path).
  echo "  ✓ Testing pgvector extension is installed..."
  docker run --rm ${image.imageName}:test bash -c \
    'ls "$(pg_config --sharedir)/extension/vector.control"'

  # Test 4: Help functionality.
  echo "  ✓ Testing help functionality..."
  docker run --rm ${image.imageName}:test postgres --help | grep -q "Usage"

  echo "✅ All postgres-cloudnative-pg tests passed!"
''
