namespace ThetisSkinMaker.Utils {

public class NoopSkinManager : ISkinManager, Object
{
    public string skin_folder {
        get {
            message("NoopSkinManager.skin_folder stub!");
            return "";
        }
    }

    internal NoopSkinManager()
    {
        Object();
    }

    public List<string> get_skins()
    {
        message("NoopSkinManager.get_skins() stub!");
        return new List<string>();
    }

    public void save_skin(string name, Gdk.Pixbuf image, string? base_name) throws Error
    {
        message("NoopSkinManager.save_skin() stub!");
    }
}

} /* namespace ThetisSkinMaker.Utils */