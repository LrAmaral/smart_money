enum RoutePath {
  firstPage(path: '/'),
  forgotPassword(path: '/forgot_password'),
  login(path: '/login'),
  register(path: '/register'),
  home(path: '/home'),
  extract(path: '/extract'),
  goals(path: '/goals'),
  profile(path: '/profile'),
  editProfile(path: '/edit_profile'),
  logout(path: '/');

  const RoutePath({required this.path});

  final String path;
}
