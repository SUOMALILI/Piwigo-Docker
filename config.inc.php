<?php
// this permit to show the php errors reporting (see INI 'error_reporting'
// for possible values)
// gives an empty value '' to deactivate
$conf['show_php_errors'] = E_ALL & ~E_NOTICE & ~E_DEPRECATED;

// newcat_default_status : at creation, must a category be public or private
// ? Warning : if the parent category is private, the category is
// automatically create private.
$conf['newcat_default_status'] = 'private';

// meta_ref to reference multiple sets of incorporated pages or elements
// Set it false to avoid referencing in Google, and other search engines.
$conf['meta_ref'] = false;

// does the guest have access ?
// (not a security feature, set your categories "private" too)
// If false it'll be redirected from index.php to identification.php
$conf['guest_access'] = false;

// question_mark_in_urls : the generated urls contain a ? sign. This can be
// changed to false only if the server translates PATH_INFO variable
// (depends on the server AcceptPathInfo directive configuration)
$conf['question_mark_in_urls'] = false;

// php_extension_in_urls : if true, the urls generated for picture and
// category will not contain the .php extension. This will work only if
// .htaccess defines Options +MultiViews parameter or url rewriting rules
// are active.
$conf['php_extension_in_urls'] = false;

// category_url_style : one of 'id' (default) or 'id-name'. 'id-name'
// means that an simplified ascii representation of the category name will
// appear in the url
$conf['category_url_style'] = 'id-name';

// Display a link to subscribe to Piwigo Announcements Newsletter
$conf['show_newsletter_subscription'] = false;

// permitted characters for files/directories during synchronization
//$conf['sync_chars_regex'] = '/^[a-zA-Z0-9-_. ]+$/';
//to support chinese
$conf['sync_chars_regex'] = '/^[\x{4e00}-\x{9fa5}a-zA-Z0-9-_.\(\)\!@#\s+]+$/u';

// Default behaviour when a new album is created: should the new album inherit the group/user
// permissions from its parent? Note that config is only used for Ftp synchro,
// and if that option is not explicitly transmit when the album is created.
$conf['inheritance_by_default'] = true;

// Size of chunks, in kilobytes. Fast connections will have better
// performances with high values, such as 5000.
$conf['upload_form_chunk_size'] = 5000;

// Log level (OFF, CRITICAL, ERROR, WARNING, NOTICE, INFO, DEBUG)
// development = DEBUG, production = ERROR
$conf['log_level'] = 'ERROR';

// remember_me_length : time of validity for "remember me" cookies, in
// seconds.
$conf['remember_me_length'] = 17280000;

// session_length : time of validity for normal session, in seconds.
$conf['session_length'] = 172800;

// show_exif_fields : in EXIF fields, you can choose to display fields in
// sub-arrays, for example ['COMPUTED']['ApertureFNumber']. for this, add
// 'COMPUTED;ApertureFNumber' in $conf['show_exif_fields']
//
// The key displayed in picture.php will be $lang['exif_field_Make'] for
// example and if it exists. For compound fields, only take into account the
// last part : for key 'COMPUTED;ApertureFNumber', you need
// $lang['exif_field_ApertureFNumber']
//
// for PHP version newer than 4.1.2 :
// $conf['show_exif_fields'] = array('CameraMake','CameraModel','DateTime');
//
$conf['show_exif'] = true;
$conf['show_exif_fields'] = array(
    'Make',
    'Model',
    'ExifVersion',
    'Software',
    'DateTimeOriginal',
    'FNumber',
    'ExposureBiasValue',
    'FILE;FileSize',
    'ExposureTime',
    'Flash',
    'ISOSpeedRatings',
    'FocalLength',
    'FocalLengthIn35mmFilm',
    'WhiteBalance',
    'ExposureMode',
    'MeteringMode',
    'ExposureProgram',
    'LightSource',
    'Contrast',
    'Saturation',
    'Sharpness',
    'bitrate',
    'channel',
    'date_creation',
    'display_aspect_ratio',
    'duration',
    'filesize',
    'format',
    'formatprofile',
    'codecid',
    'frame_rate',
    'latitude',
    'longitude',
    'make',
    'model',
    'playtime_seconds',
    'sampling_rate',
    'type',
    'resolution',
    'rotation',
    );
// use_exif: Use EXIF data during database synchronization with files
// metadata
$conf['use_exif'] = true;

// use_exif_mapping: same behaviour as use_iptc_mapping
$conf['use_exif_mapping'] = array(
  'date_creation' => 'DateTimeOriginal',
  'author' => 'Artist',
);

// send_bcc_mail_webmaster: send bcc mail to webmaster. Set true for debug
// or test.
$conf['send_bcc_mail_webmaster'] = false;

// define the name of sender mail: if value is empty, gallery title is used
$conf['mail_sender_name'] = 'photos.xxx.xxx';

// define the email of sender mail: if value is empty, webmaster email is used
$conf['mail_sender_email'] = '';

// set true to allow text/html emails
$conf['mail_allow_html'] = true;

// smtp configuration (work if fsockopen function is allowed for smtp port)
// smtp_host: smtp server host
//  if null, regular mail function is used
//   format: hoststring[:port]
//   exemple: smtp.pwg.net:21
// smtp_user/smtp_password: user & password for smtp authentication
$conf['smtp_host'] = 'smtp.xxxxx.xx:25';
$conf['smtp_user'] = '';
$conf['smtp_password'] = '';

// 'ssl' or 'tls'
$conf['smtp_secure'] = null;

// show_iptc: Show IPTC metadata on picture.php if asked by user
$conf['show_iptc'] = true;

// use_iptc: Use IPTC data during database synchronization with files
// metadata
$conf['use_iptc'] = true;

// 'small', 'medium' or 'large'
$conf['derivative_default_size'] = 'large';

// Support X-Forwarded-Proto header for HTTPS detection
if ( $_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https' ) {
    $_SERVER['HTTPS'] = 'on';
}
// Support for X-Forwarded-For header
if ($_SERVER['HTTP_X_FORWARDED_FOR']) {
    $_SERVER['REMOTE_ADDR'] = $_SERVER['HTTP_X_FORWARDED_FOR'];
}
?>