;; for configuration - projectile-project-configure-cmd
;; for compilation - projectile-project-compilation-cmd
;; for testing - projectile-project-test-cmd
;; for installation - projectile-project-install-cmd
;; for packaging - projectile-project-package-cmd
;; for running - projectile-project-run-cmd
;; for configuring the test prefix - projectile-project-test-prefix
;; for configuring the test suffix - projectile-project-test-suffix
;; for configuring the related-files-fn property - projectile-project-related-files-fn
;; for configuring the src-dir property - projectile-project-src-dir
;; for configuring the test-dir property - projectile-project-test-dir
;; projectile-configure-use-separate-buffer
;; projectile-compile-use-separate-buffer
;; projectile-test-use-separate-buffer
;; projectile-package-use-separate-buffer
;; projectile-run-use-separate-buffer
;; projectile-install-use-separate-buffer


((nil . ((projectile-project-install-cmd . "./action.fish copy")
	 (projectile-install-buffer-suffix . "install")

         (projectile-project-compilation-cmd . "luacheck .")
         (projectile-compile-buffer-suffix . "lint")

	 (projectile-project-package-cmd . "./action.fish zip")
	 (projectile-package-buffer-suffix . "install")

         (projectile-project-uninstall-cmd . "./action.fish clear")
	 (projectile-uninstall-buffer-suffix . "install")

         (projectile-project-run-cmd . "factorio"))))
