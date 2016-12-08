%swift_bindir %{_bindir}
%swift_libdir /usr/lib/swift/linux
%swift_moduledir /usr/lib/swift/linux/x86_64
%swift_clangmoduleroot /usr/lib/swift

%swift_package_name %(swift package dump-package --input %{_builddir}/%{buildsubdir}/Package.swift | perl -MJSON::XS -lwe 'print decode_json(<>)->{name}')

%swift_package_url %{url}.git
%swift_package_ssh_url %{expand: \
%global swift_package_url %%(echo %%{url}.git | sed 's#^https\\\\?://#git@#; s#/#:#')
}

%swift_embed_package() %{expand:%global _swift_embed_package '%{?_swift_embed_package:%{_swift_embed_package}, }\"%{1}\"}'

%_find_swift_modules %{_rpmconfigdir}/find-swift-modules

%swift_patch_package \
	echo 'let embed: Set<String> = [%{?_swift_embed_package}]' >> Package.swift ; \
	echo 'package.dependencies = package.dependencies.filter { embed.contains($0.url) }' >> Package.swift ; \
	swift_modules=`%_find_swift_modules -printf '"%s"' -F ', ' swift-library` ; \
	echo 'products.append(Product(name: "swift" + package.name, type: .Library(.Dynamic), modules: ['${swift_modules}']))' >> Package.swift

%_swift_build %{?_swift_embed_package:sh -c 'swift build $* && }swift build -Xswiftc -module-link-name=swift%{swift_package_name}%{?_swift_embed_package: $*' --}
%swift_build %{_swift_build} -c release -Xcc -D_GNU_SOURCE

%swift_install \
	mkdir -p %{buildroot}%{swift_libdir} ; \
	cp .build/release/*.so %{buildroot}%{swift_libdir}/ ; \
	mkdir -p %{buildroot}%{swift_bindir} ; \
	for m in `%_find_swift_modules swift-executable`; do \
			cp .build/release/$m %{buildroot}%{swift_bindir}/ ; \
	done

%swift_install_devel \
	mkdir -p %{buildroot}%{swift_moduledir} ; \
	for m in `%_find_swift_modules swift-library`; do \
			cp .build/release/$m.{swiftmodule,swiftdoc} %{buildroot}%{swift_moduledir}/ ; \
	done ; \
	for m in `%_find_swift_modules clang-library`; do \
			mkdir -p %{buildroot}%{swift_clangmoduleroot}/$m/ ; \
			cp Sources/$m/include/* %{buildroot}%{swift_clangmoduleroot}/$m/ ; \
	done

# macro to invoke the Swift provides and requires generators
%swift_find_provides_and_requires %{expand: \
%global _use_internal_dependency_generator 0
%global __find_provides %%{_rpmconfigdir}/swift.prov %%{swift_package_url} %%{version}
%global __find_requires %%{_rpmconfigdir}/swift.req %%{_builddir}/%%{buildsubdir}
}
