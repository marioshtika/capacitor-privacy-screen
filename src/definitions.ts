/**
 * Plugin version payload.
 */
export interface PluginVersionResult {
  /**
   * Version identifier returned by the platform implementation.
   */
  version: string;
}

/**
 * Current privacy screen state.
 */
export interface PrivacyScreenStatus {
  /**
   * Whether privacy protection is currently enabled.
   */
  enabled: boolean;
}

/**
 * Capacitor API for protecting app content from the app switcher preview.
 */
export interface PrivacyScreenPlugin {
  /**
   * Enables the privacy screen.
   *
   * On Android this sets `FLAG_SECURE`, which also blocks screenshots and screen recording.
   * On iOS this restores the app-switcher overlay that hides your app while it is backgrounded.
   */
  enable(): Promise<PrivacyScreenStatus>;

  /**
   * Disables the privacy screen.
   *
   * Use this only when you explicitly want the current screen to remain visible in system previews.
   */
  disable(): Promise<PrivacyScreenStatus>;

  /**
   * Returns the current enabled state.
   */
  isEnabled(): Promise<PrivacyScreenStatus>;

  /**
   * Returns the native implementation version marker.
   */
  getPluginVersion(): Promise<PluginVersionResult>;
}
