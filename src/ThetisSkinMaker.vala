namespace ThetisSkinMaker {

public class Application : Gtk.Application
{
    public Application()
    {
        Object(application_id: "io.github.ydalton.ThetisSkinMaker",
                flags: ApplicationFlags.DEFAULT_FLAGS);
    }

    public override void startup()
    {
        base.startup();

        var builder = new Gtk.Builder();
        try {
            builder.add_from_resource("/io/github/ydalton/ThetisSkinMaker/ui/menu.ui");
        } catch (Error e) {
            show_error_box("Internal Error", "An internal error occured. This should not happen. " + e.message);
        }

        var menubar = builder.get_object("menubar") as MenuModel;
        assert(menubar != null);

        this.menubar = menubar;
    }

    public override void activate()
    {
        var window = new ThetisSkinMaker.Window(this);
        window.present();
    }

    public static int main(string[] args)
    {
        var application = new ThetisSkinMaker.Application();
        /* HACK for now */
        Environment.set_variable("GTK_THEME", "win32", true);
        return application.run();
    }
}

} // namespace ThetisSkinMaker