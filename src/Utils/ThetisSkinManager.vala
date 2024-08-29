extern int show_info_box(string title, string text);
extern int show_warning_box(string title, string text);
extern int show_error_box(string title, string text);
extern int show_yes_no_box(string title, string text);

enum MessageBoxResponse {
    IDCANCEL = 2,
    IDYES = 6,
    IDNO = 7,
}

namespace ThetisSkinMaker.Utils {

public class ThetisSkinManager : ISkinManager, Object
{
    /*
     * We cannot embed the environment variable when opening a path, so we need
     * to expand it at runtime.
     */
    const string THETIS_SKIN_PATH = "OpenHPSDR\\Skins";
    const string THETIS_PICDISPLAY_PATH = "Console\\picDisplay.png";

    private string _skin_folder;
    public string skin_folder {
        get {
            if(_skin_folder == null) {
                var appdata = Environment.get_variable("APPDATA");
                assert(appdata != null);
                _skin_folder = Path.build_filename(appdata,
                                                   THETIS_SKIN_PATH);
            }
            return _skin_folder;
        }
    }

    internal ThetisSkinManager()
    {
        Object();
    }

    /*
     * Retrieves the available skins in the skin folder.
     */
    public List<string> get_skins()
    {
        List<string> list;

        list = new List<string>();

        Dir dir;
        try {
            dir = Dir.open(skin_folder);
        } catch(Error e) {
            return list;
        }

        string? name = null;
        while((name = dir.read_name()) != null) {
            string file_full_path = Path.build_filename(skin_folder, name);
            if(!FileUtils.test(file_full_path, FileTest.IS_DIR))
                continue;

            /* we need a picdisplay.png file in the folder, otherwise it's not
             * a valid skin for Thetis
             */
            if(!FileUtils.test(Path.build_filename(file_full_path,
                                                   THETIS_PICDISPLAY_PATH), FileTest.EXISTS))
                continue;

            list.append(name);
        }

        return list;
    }

    /*
     * Saves a skin to the Thetis skin folder.
     */
    public void save_skin(string name, Gdk.Pixbuf image, string? base_skin) throws Error
    {
        /* FIXME: hardcoded */
        if(base_skin == null)
            base_skin = "W1AEX Dark Metal";

        /*
         * Steps:
         * - Copy the base folder into the new skin folder (xcopy)
         * - Rename the new skin folder into @name;
         * - Export the @image into the picDisplay.png file.
         */

        /* trailing \ to make xcopy happy */
        var base_skin_path = Path.build_filename(skin_folder, base_skin) + "\\";
        assert(FileUtils.test(base_skin_path, FileTest.EXISTS));
        message("%s", base_skin_path);

        var new_skin_path = Path.build_filename(skin_folder, name) + "\\";
        message("%s", new_skin_path);

        if(FileUtils.test(new_skin_path, FileTest.EXISTS))
            throw new SkinError.CODE_FOLDER_EXISTS("A skin with that name already exists.");
        /*
         * XXX: perform sanitization?
         */
        string xcopy_cmd = @"xcopy '$base_skin_path' '$new_skin_path' /s /e /q";

        message("%s", xcopy_cmd);

        try {
            Process.spawn_command_line_sync(xcopy_cmd);
        } catch (SpawnError e) {
            throw new SkinError.CODE_UNKNOWN_ERROR(e.message);
        }

        var picdpy = Path.build_filename(new_skin_path,
                                         THETIS_PICDISPLAY_PATH);

        message("%s", picdpy);

        try {
            image.save(picdpy, "png");
        } catch (Error e) {
            throw e;
        }
    }
}

} /* namespace ThetisSkinMaker */