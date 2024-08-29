namespace ThetisSkinMaker.Utils {

public interface ISkinManager : Object
{
    public abstract string skin_folder { get; }
    public abstract List<string> get_skins();
    public abstract void save_skin(string name, Gdk.Pixbuf image, string? base_skin) throws Error;
}

} /* namespace ThetisSkinMaker.Utils */