import re
import glob

def replace_in_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # Remove the import
    content = re.sub(r"import 'package:laci_mobile/widgets/custom_refresh_control.dart';\n", "", content)

    # We need to find CustomRefreshControl(onRefresh: _onRefresh, primaryColor: ...)
    # and remove it from slivers
    content = re.sub(r"\s*CustomRefreshControl\([^)]+\),", "", content)

    # And we need to wrap CustomScrollView with RefreshIndicator
    # We will use regex to find CustomScrollView( and replace it with RefreshIndicator(onRefresh: _onRefresh, color: primaryColor, child: CustomScrollView(
    # Wait, the color/onRefresh variables might be named differently in each file!
    
    with open(filepath, 'w') as f:
        f.write(content)

files = [
    "lib/screens/home_screen.dart",
    "lib/screens/aktivitas/riwayat_aktivitas_screen.dart",
    "lib/screens/periode/periode_screen.dart",
    "lib/screens/aktivitas/detail_riwayat_aktivitas_screen.dart",
    "lib/screens/profile_screen.dart",
    "lib/screens/pengguna/pengguna_screen.dart",
    "lib/screens/pengguna/detail_pengguna_screen.dart"
]

# Just print the match first
for file in files:
    with open(file, 'r') as f:
        content = f.read()
    
    matches = re.findall(r"(CustomRefreshControl\([^)]+\))", content)
    print(f"{file}: {len(matches)} usages")
    for m in matches:
        print(f"  {m}")

