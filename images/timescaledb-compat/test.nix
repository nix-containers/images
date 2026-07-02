{ pkgs, image }:

pkgs.writeShellScript "test-timescaledb-compat" ''
  set -euo pipefail

  echo "🧪 Testing timescaledb-compat image functionality..."

  # Test 1: PostgreSQL version (passed through by the entrypoint).
  echo "  ✓ Testing postgres version..."
  docker run --rm ${image.imageName}:test postgres --version | grep -q "postgres"

  # Test 2: PostgreSQL client tools.
  echo "  ✓ Testing postgres tools..."
  docker run --rm ${image.imageName}:test which psql | grep -q "psql"

  # Test 3: TimescaleDB extension is bundled (control file on the extension path).
  echo "  ✓ Testing TimescaleDB extension is installed..."
  docker run --rm ${image.imageName}:test bash -c \
    'ls "$(pg_config --sharedir)/extension/timescaledb.control"'

  # Test 4: Help functionality.
  echo "  ✓ Testing help functionality..."
  docker run --rm ${image.imageName}:test postgres --help | grep -q "Usage"

  echo "✅ All timescaledb-compat tests passed!"
''
