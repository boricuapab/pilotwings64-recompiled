#include "pilotwings64_launcher.h"
#include "elements/ui_image.h"
#include "util/file.h"
#include <fstream>
#include <iterator>
#include <stdexcept>

void pilotwings64::launcher_animation_setup(recompui::LauncherMenu* menu) {
    auto context = recompui::get_current_context();
    auto background = menu->get_background_container();
    background->set_background_color({8, 18, 32, 255});
    std::ifstream input(recompui::file::get_asset_path("pilotwings-splash.png"), std::ios::binary);
    if (!input) {
        throw std::runtime_error("Missing assets/pilotwings-splash.png. Extract the complete release package.");
    }
    std::vector<char> bytes{std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>()};
    const std::string texture_id = "?/launcher/pilotwings-splash";
    recompui::queue_image_from_bytes_file(texture_id, bytes);
    auto splash = context.create_element<recompui::Image>(background, texture_id);
    splash->set_position(recompui::Position::Absolute);
    splash->set_height(100, recompui::Unit::Percent);
    splash->set_width_auto();
    splash->set_left(0);
    splash->set_top(0);
}

void pilotwings64::launcher_animation_update(recompui::LauncherMenu*) {}
