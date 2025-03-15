<template>
  <div
    id="app"
    @keyup="keyup"
    tabindex="-1"
    :class="{
      night: grimoire.isNight,
      static: grimoire.isStatic
    }"
    :style="{
      backgroundImage: grimoire.background
        ? `url('${grimoire.background}')`
        : ''
    }"
  >
    <video
      id="background"
      v-if="grimoire.background && grimoire.background.match(/\.(mp4|webm)$/i)"
      :src="grimoire.background"
      autoplay
      loop
    ></video>
    <div class="backdrop"></div>
    <transition name="blur">
      <Intro v-if="!players.length"></Intro>
      <TownInfo v-if="players.length && !session.nomination"></TownInfo>
      <Vote v-if="session.nomination"></Vote>
    </transition>
    <TownSquare></TownSquare>
    <Menu ref="menu"></Menu>
    <EditionModal />
    <FabledModal />
    <RolesModal />
    <ReferenceModal />
    <NightOrderModal />
    <VoteHistoryModal />
    <GameStateModal />
    <Gradients />
    <span id="version">v{{ version }}</span>
  </div>
</template>

<script>
import { mapState } from "vuex";
import { version } from "../package.json";
import TownSquare from "./components/TownSquare";
import TownInfo from "./components/TownInfo";
import Menu from "./components/Menu";
import RolesModal from "./components/modals/RolesModal";
import EditionModal from "./components/modals/EditionModal";
import Intro from "./components/Intro";
import ReferenceModal from "./components/modals/ReferenceModal";
import Vote from "./components/Vote";
import Gradients from "./components/Gradients";
import NightOrderModal from "./components/modals/NightOrderModal";
import FabledModal from "@/components/modals/FabledModal";
import VoteHistoryModal from "@/components/modals/VoteHistoryModal";
import GameStateModal from "@/components/modals/GameStateModal";

export default {
  components: {
    GameStateModal,
    VoteHistoryModal,
    FabledModal,
    NightOrderModal,
    Vote,
    ReferenceModal,
    Intro,
    TownInfo,
    TownSquare,
    Menu,
    EditionModal,
    RolesModal,
    Gradients
  },
  computed: {
    ...mapState(["grimoire", "session"]),
    ...mapState("players", ["players"])
  },
  data() {
    return {
      version
    };
  },
  methods: {
    keyup({ key, ctrlKey, metaKey }) {
      if (ctrlKey || metaKey) return;
      switch (key.toLocaleLowerCase()) {
        case "g":
          this.$store.commit("toggleGrimoire");
          break;
        case "a":
          this.$refs.menu.addPlayer();
          break;
        case "h":
          this.$refs.menu.hostSession();
          break;
        case "j":
          this.$refs.menu.joinSession();
          break;
        case "r":
          this.$store.commit("toggleModal", "reference");
          break;
        case "n":
          this.$store.commit("toggleModal", "nightOrder");
          break;
        case "e":
          if (this.session.isSpectator) return;
          this.$store.commit("toggleModal", "edition");
          break;
        case "c":
          if (this.session.isSpectator) return;
          this.$store.commit("toggleModal", "roles");
          break;
        case "v":
          if (this.session.voteHistory.length || !this.session.isSpectator) {
            this.$store.commit("toggleModal", "voteHistory");
          }
          break;
        case "s":
          if (this.session.isSpectator) return;
          this.$refs.menu.toggleNight();
          break;
        case "escape":
          this.$store.commit("toggleModal");
      }
    }
  }
};
</script>

<style lang="scss">
@import "vars";

html,
body {
  font-size: 1.2em;
  line-height: 1.4;
  background: #f0e0d0;
  background-size: cover;
  color: black;
  height: 100%;
  font-family: sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  padding: 0;
  margin: 0;
  overflow: hidden;
}

@import "media";

* {
  box-sizing: border-box;
  position: relative;
}

a {
  color: $townsfolk;
  &:hover {
    color: $demon;
  }
}

h1,
h2,
h3,
h4,
h5 {
  margin: 0;
  text-align: center;
  font-family: sans-serif;
  letter-spacing: 1px;
  font-weight: normal;
}

ul {
  list-style-type: none;
  margin: 0;
  padding: 0;
}

#app {
  height: 100%;
  background-position: center center;
  background-size: cover;
  display: flex;
  align-items: center;
  align-content: center;
  justify-content: center;

  // disable all animations
  &.static *,
  &.static *:after,
  &.static *:before {
    transition: none !important;
    animation: none !important;
  }
}

#version {
  position: absolute;
  text-align: right;
  right: 10px;
  bottom: 10px;
  font-size: 60%;
  opacity: 0.5;
}

.blur-enter-active,
.blur-leave-active {
  transition: all 250ms;
  filter: blur(0);
}
.blur-enter,
.blur-leave-to {
  opacity: 0;
  filter: blur(20px);
}

// Buttons
.button-group {
  display: flex;
  align-items: center;
  justify-content: center;
  align-content: center;
  .button {
    margin: 5px 0;
    border-radius: 0;
    &:first-child {
      border-top-left-radius: 15px;
      border-bottom-left-radius: 15px;
    }
    &:last-child {
      border-top-right-radius: 15px;
      border-bottom-right-radius: 15px;
    }
  }
}
.button {
  padding: 0;
  border: solid 0.125em transparent;
  border-radius: 15px;
  border: 4px solid black;
  color: black;
  font-weight: bold;
  line-height: 170%;
  margin: 5px auto;
  cursor: pointer;
  transition: all 200ms;
  white-space: nowrap;
  &:hover {
    color: $fabled;
    border-color: $fabled;
  }
  &.disabled {
    color: gray;
    cursor: default;
    opacity: 0.75;
  }
  &:before,
  &:after {
    content: " ";
    display: inline-block;
    width: 10px;
    height: 10px;
  }
  &.townsfolk {
    &:hover:not(.disabled) {
      color: $townsfolk;
    }
  }
  &.demon {
    color: $demon;
  }
}

/* video background */
video#background {
  position: absolute;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* Night phase backdrop */
#app > .backdrop {
  position: absolute;
  left: 0;
  right: 0;
  bottom: 0;
  background: #8ca1b7;
  top: 0;
  pointer-events: none;
  opacity: 0;
  transition: opacity 1s ease-in-out;
  &:after {
    content: " ";
    display: block;
    width: 100%;
    padding-right: 2000px;
    height: 100%;
    opacity: 0.3;
  }
}

#app.night > .backdrop {
  opacity: 0.3;
}
</style>
