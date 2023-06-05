enum Dist {
  debian,
  ubuntu,
  centos,
  fedora,
  opensuse,
  kali,
  wrt,
  armbian,
  arch,
  alpine,
  rocky;
}

extension StringX on String {
  Dist? get dist {
    final lower = toLowerCase();
    for (final dist in Dist.values) {
      if (lower.contains(dist.name)) {
        return dist;
      }
    }
    return null;
  }
}
