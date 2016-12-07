%swift_bindir %{_bindir}
%swift_libdir /usr/lib/swift/linux
%swift_moduledir /usr/lib/swift/linux/x86_64
%swift_clangmoduleroot /usr/lib/swift

%swift_link_name %(echo %{name} | sed 's/-//')

%swift_package_url %{url}.git
%swift_package_ssh_url %{expand: \
%global swift_package_url %%(echo %%{url}.git | sed 's#^https\\\\?://#git@#; s#/#:#')
}

%swift_embed_package() %{expand:%global _swift_embed_package '%{?_swift_embed_package:%{_swift_embed_package}, }\"%{1}\"}'

%swift_bins `find Sources/* -maxdepth 0 -type d -exec test -f {}/main.swift \\; -printf '%f '`
%swift_modules `find Sources/* -maxdepth 0 -type d -exec test \\! -d {}/include -a \\! -f {}/main.swift \\; -printf '%f '`
%swift_clangmodules `find Sources/* -maxdepth 0 -type d -exec test -d {}/include \\; -printf '%f '`

%swift_patch_package \
	echo 'let embed: Set<String> = [%{?_swift_embed_package}]' >> Package.swift ; \
	echo 'package.dependencies = package.dependencies.filter { embed.contains($0.url) }' >> Package.swift ; \
	swift_modules=%{swift_modules} ; \
	modules_array=`echo $swift_modules | sed 's/\\(\\S\\+\\)/"\\1",/g'` ; \
	echo 'products.append(Product(name: "%{swift_link_name}", type: .Library(.Dynamic), modules: ['"${modules_array}"']))' >> Package.swift

%_swift_build %{?_swift_embed_package:sh -c 'swift build $* && }swift build -Xswiftc -module-link-name=%{swift_link_name}%{?_swift_embed_package: $*' --}
%swift_build %{_swift_build} -c release -Xcc -D_GNU_SOURCE

%swift_install \
	mkdir -p %{buildroot}%{swift_libdir} ; \
	cp .build/release/*.so %{buildroot}%{swift_libdir}/ ; \
	mkdir -p %{buildroot}%{swift_bindir} ; \
	for m in %{swift_bins}; do \
			cp .build/release/$m %{buildroot}%{swift_bindir}/ ; \
	done

%swift_install_devel \
	mkdir -p %{buildroot}%{swift_moduledir} ; \
	for m in %{swift_modules}; do \
			cp .build/release/$m.{swiftmodule,swiftdoc} %{buildroot}%{swift_moduledir}/ ; \
	done ; \
	for m in %{swift_clangmodules}; do \
			mkdir -p %{buildroot}%{swift_clangmoduleroot}/$m/ ; \
			cp Sources/$m/include/* %{buildroot}%{swift_clangmoduleroot}/$m/ ; \
	done

# macro to invoke the Swift provides and requires generators
%swift_find_provides_and_requires %{expand: \
%global _use_internal_dependency_generator 0
%global __find_provides %%{_rpmconfigdir}/swift.prov %%{swift_package_url} %%{version}
%global __find_requires %%{_rpmconfigdir}/swift.req %%{_builddir}/%%{buildsubdir}
}
