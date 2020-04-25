<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'tickry' );

/** MySQL database password */
define( 'DB_PASSWORD', 'Ly9ANY04AaaJRQbETn' );

/** MySQL hostname */
define( 'DB_HOST', 'rdscloudedinsight.c7es0yozwq3s.us-east-2.rds.amazonaws.com:3306' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'tgW<-sl_e0 1xiiM42%*=jM[_}h3(b!Em~dvt5yj#y8yJL}w6>E@P}b+>&r=]MgJ' );
define( 'SECURE_AUTH_KEY',  'E)@3[n/e<37L*.vs]%W9[eM=C1N-PiXLz!E< yK1[3IQ 6WD}6ous@j~Zy9$`B!}' );
define( 'LOGGED_IN_KEY',    'q~L.HbL|!FcXq?<!?KF,Yw(!;jdQ803./C!s$Xj_]DM(W`9MiY9M;}V/Ll::6W(`' );
define( 'NONCE_KEY',        'oLB@a_g>EZ[{92/J{l2gd-.H`1.5[/A}OV(87W%``47i-puw[fQ@UKe,w{-i5>2L' );
define( 'AUTH_SALT',        'MtOK.pJM4Deo&ZUD63sryQ|bbDO=g8TB1N<i<7[W#?7D&U_5|?dTZu:DHcs}`*_8' );
define( 'SECURE_AUTH_SALT', 'U&E(EWcLxm>(im@XpAGpj(m7CIF0P/X=.ASX(u$RY&{}kW:e@a+D`=XpB?cj9 YQ' );
define( 'LOGGED_IN_SALT',   '<`6_?9m~}G+Wc~;|z~Gc.wh8svlmn@+)x}k@f0wG1vcTYJ~6b2NJnPV9C.|Q;k,8' );
define( 'NONCE_SALT',       '9=S%MuG|ov#FCH;v-+-RzzPf1Z/>6*G r0@Foy1f{z8`MC{/uWCg6orxKU.J7riq' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
