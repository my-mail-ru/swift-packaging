%swift_bindir %{_bindir}
%swift_libdir /usr/lib/swift/linux
%swift_moduledir /usr/lib/swift/linux/x86_64
%swift_clangmoduleroot /usr/lib/swift

%swift_package_url %{url}.git
%swift_package_ssh_url %{expand: \
%global swift_package_url %%(echo %%{url}.git | sed 's#^https\\\\?://#git@#; s#/#:#')
}

%swift_patch_package true

%swift_build swift local --build-path=.rpmbuild \\\
	--install-path=%{buildroot}%{_prefix} \\\
	--perl5lib=%{buildroot}%{perl_vendorarch} \\\
	build -c release -Xcc -D_GNU_SOURCE

%swift_install swift local \\\
	--build-path=.rpmbuild \\\
	--install-path=%{buildroot}%{_prefix} \\\
	--perl5lib=%{buildroot}%{perl_vendorarch} \\\
	install -c release --type runtime

%swift_install_devel swift local \\\
	--build-path=.rpmbuild \\\
	--install-path=%{buildroot}%{_prefix} \\\
	--perl5lib=%{buildroot}%{perl_vendorarch} \\\
	install -c release --type devel

# macro to invoke the Swift provides and requires generators
%swift_find_provides_and_requires %{expand: \
%global _use_internal_dependency_generator 0
%global __find_provides %%{_rpmconfigdir}/swift.prov %%{swift_package_url} %%{version}
%global __find_requires %%{_rpmconfigdir}/swift.req %%{_builddir}/%%{buildsubdir}
}
